import Vapor
import Fluent
import FluentPostgresDriver
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: Environment.get("DB_HOST_NAME") ?? "",
                username: Environment.get("DB_USER_NAME") ?? "",
                password: "",
                database: Environment.get("DB_NAME") ?? "",
                tls: .prefer(try .init(configuration: .clientDefault))
            )
        ),
        as: .psql
    )
    // register migrations
    app.migrations.add(CreateUsersTableMigration())
    app.migrations.add(CreatePubItemsMigration())
    app.migrations.add(CreateMovementsMigration())
//    app.migrations.add()
    
    // register controllers
    try app.register(collection: UserController())
    try app.register(collection: PubItemController())
    try app.register(collection: MovementController())
    
    await app.jwt.keys.add(hmac: HMACKey(stringLiteral: Environment.get("DB_SECRET_KEY") ?? ""), digestAlgorithm: .sha256)
    
    // register routes
    try routes(app)
}
