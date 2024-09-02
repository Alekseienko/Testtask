import UIKit

final class UsersViewModel {
    
    // MARK: - Properties
    
    //// Array to hold the user data
    private var data: [UserModel] = []
    //// Indicates whether data is currently being loaded
    private(set) var isLoading = false
    //// Tracks the current page for pagination
    private var currentPage = 1
    /// Number of items to fetch per page
    private let itemsPerPage = 6
    /// Indicates if there is more data to fetch
    var hasMoreData = true
    
    /// Bindable properties to notify about updates, errors, and new users
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onNewUserAdded: (() -> Void)?
    
    /// Network service for making API requests
    private let networkService: NetworkService
    
    /// NwUser 
    private var newUser: UserModel?
    
    // MARK: - Initializer
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: - Computed Properties
    
    /// Returns the number of items in the data array
    var numberOfItems: Int {
        return data.count
    }
    
    /// Returns the user model at the specified index
    func item(at index: Int) -> UserModel {
        return data[index]
    }
    
    // MARK: - Public Methods
    
    /// Loads a new user by ID and updates the data
    func loadNewUserBy(id: Int?) {
        Task { @MainActor in
            do {
                guard let id else {
                    return
                }
                /// Fetch user data from the network
                let userResponse = try await networkService.getUserBy(id: id)
                let newUser = userResponse.user
                
                /// Check if the user already exists in the data
                guard !data.contains(where: { $0.id == newUser.id }) else {
                    print("User with ID \(String(describing: id)) already exists in the data array.")
                    return
                }
                
                /// Load images for the new user
                let newUserModels = await loadImagesForUsers([newUser])
                guard let newUserModel = newUserModels.first else { return }
                
                self.newUser = newUserModel
                onNewUserAdded?()
                
            } catch {
                print("⚠️", #function, error.localizedDescription)
                onError?(error.localizedDescription)
            }
        }
    }

    // Loads a page of users and updates the data
    func loadUsers() async throws {
        do {
            /// Set loading state and fetch users from the network
            self.isLoading = true
            let usersResponse = try await self.networkService.fetchUsers(page: self.currentPage, count: self.itemsPerPage)
            self.isLoading = false
            
            /// Check if there are no more users to load
            if usersResponse.users.isEmpty || usersResponse.users.count < self.itemsPerPage {
                self.hasMoreData = false
            }
            
            /// Filter out users already in the data array
            let newUsers = usersResponse.users.filter { newUser in
                !self.data.contains(where: { $0.id == newUser.id })
            }
            
            /// Load images for the new users
            let newUserModels = await self.loadImagesForUsers(newUsers)
            self.data.append(contentsOf: newUserModels)
            self.sortData()
            self.onDataUpdated?()
            
            /// Increment the page number if new users were added
            if !newUserModels.isEmpty {
                self.currentPage += 1
            }
            
        } catch {
            self.isLoading = false
            /// Propagate the error to the caller
            throw error
        }
    }
    /// Append new user if !=nil
    func appendNewUser() async -> Bool {
        if let user = newUser {
            data.insert(user, at: 0)
            newUser = nil
            return true
        } else {
            return false
        }
    }

    // MARK: - Private Methods
    
    /// Sorts the user data by registration timestamp in descending order
    private func sortData() {
        data.sort { $0.registrationTimestamp > $1.registrationTimestamp }
    }
    
    /// Loads images for a list of users and returns user models with images
    private func loadImagesForUsers(_ users: [User]) async -> [UserModel] {
        await withTaskGroup(of: UserModel.self) { group in
            var userModels: [UserModel] = []
            let currentDate = Date()
            for user in users {
                group.addTask { @MainActor in
                    guard let url = URL(string: user.photo) else {
                        return UserModel(
                            id: user.id,
                            name: user.name,
                            email: user.email,
                            phone: user.phone.formattedPhoneNumber(),
                            position: user.position,
                            registrationTimestamp: user.registrationTimestamp ?? Int(currentDate.timeIntervalSince1970),
                            photo: .photoCover
                        )
                    }
                    let image = await self.fetchImage(from: url)
                    return UserModel(
                        id: user.id,
                        name: user.name,
                        email: user.email,
                        phone: user.phone.formattedPhoneNumber(),
                        position: user.position,
                        registrationTimestamp: user.registrationTimestamp ?? Int(currentDate.timeIntervalSince1970),
                        photo: image ?? .photoCover
                    )
                }
            }

            for await userModel in group {
                userModels.append(userModel)
            }

            return userModels
        }
    }
    
    /// Fetches an image from a URL and returns it as a UIImage
    private func fetchImage(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Error fetching image: \(error.localizedDescription)")
            return nil
        }
    }
}
