extension FetchedCollection where Fetched: RowConvertible {
    // MARK: - Initialization
    
    /// Creates a fetched records controller initialized from a SQL query and
    /// its eventual arguments.
    ///
    ///     let controller = FetchedCollection<Wine>(
    ///         dbQueue,
    ///         sql: "SELECT * FROM wines WHERE color = ? ORDER BY name",
    ///         arguments: [Color.red],
    ///         isSameElement: { (wine1, wine2) in wine1.id == wine2.id })
    ///
    /// - parameters:
    ///     - databaseWriter: A DatabaseWriter (DatabaseQueue, or DatabasePool)
    ///     - sql: An SQL query.
    ///     - arguments: Optional statement arguments.
    ///     - adapter: Optional RowAdapter
    ///     - queue: Optional dispatch queue (defaults to the main queue)
    ///
    ///         The fetched records controller delegate will be notified of
    ///         record changes in this queue. The controller itself must be used
    ///         from this queue.
    ///
    ///         This dispatch queue must be serial.
    ///
    ///     - isSameElement: Optional function that compares two records.
    ///
    ///         This function should return true if the two records have the
    ///         same identity. For example, they have the same id.
    public convenience init(
        _ databaseWriter: DatabaseWriter,
        sql: String,
        arguments: StatementArguments? = nil,
        adapter: RowAdapter? = nil,
        queue: DispatchQueue = .main) throws
    {
        try self.init(
            databaseWriter,
            request: SQLRequest(sql, arguments: arguments, adapter: adapter).bound(to: Fetched.self),
            queue: queue,
            unwrap: { $0.unwrap() })
    }
    
    /// Creates a fetched records controller initialized from a fetch request
    /// from the [Query Interface](https://github.com/groue/GRDB.swift#the-query-interface).
    ///
    ///     let request = Wine.order(Column("name"))
    ///     let controller = FetchedCollection<Wine>(
    ///         dbQueue,
    ///         request: request,
    ///         isSameElement: { (wine1, wine2) in wine1.id == wine2.id })
    ///
    /// - parameters:
    ///     - databaseWriter: A DatabaseWriter (DatabaseQueue, or DatabasePool)
    ///     - request: A fetch request.
    ///     - queue: Optional dispatch queue (defaults to the main queue)
    ///
    ///         The fetched records controller delegate will be notified of
    ///         record changes in this queue. The controller itself must be used
    ///         from this queue.
    ///
    ///         This dispatch queue must be serial.
    ///
    ///     - isSameElement: Optional function that compares two records.
    ///
    ///         This function should return true if the two records have the
    ///         same identity. For example, they have the same id.
    public convenience init<Request>(
        _ databaseWriter: DatabaseWriter,
        request: Request,
        queue: DispatchQueue = .main) throws
        where Request: TypedRequest, Request.Fetched == Fetched
    {
        try self.init(
            databaseWriter,
            request: request,
            queue: queue,
            unwrap: { $0.unwrap() })
    }
}

#if os(iOS)
    extension FetchedCollection where Fetched: RowConvertible {
        // MARK: - Initialization
        
        /// Creates a fetched records controller initialized from a SQL query and
        /// its eventual arguments.
        ///
        ///     let controller = FetchedCollection<Wine>(
        ///         dbQueue,
        ///         sql: "SELECT * FROM wines WHERE color = ? ORDER BY name",
        ///         arguments: [Color.red],
        ///         isSameElement: { (wine1, wine2) in wine1.id == wine2.id })
        ///
        /// - parameters:
        ///     - databaseWriter: A DatabaseWriter (DatabaseQueue, or DatabasePool)
        ///     - sql: An SQL query.
        ///     - arguments: Optional statement arguments.
        ///     - adapter: Optional RowAdapter
        ///     - queue: Optional dispatch queue (defaults to the main queue)
        ///
        ///         The fetched records controller delegate will be notified of
        ///         record changes in this queue. The controller itself must be used
        ///         from this queue.
        ///
        ///         This dispatch queue must be serial.
        ///
        ///     - isSameElement: Optional function that compares two records.
        ///
        ///         This function should return true if the two records have the
        ///         same identity. For example, they have the same id.
        public convenience init(
            _ databaseWriter: DatabaseWriter,
            sql: String,
            arguments: StatementArguments? = nil,
            adapter: RowAdapter? = nil,
            queue: DispatchQueue = .main,
            isSameElement: @escaping (Fetched, Fetched) -> Bool) throws
        {
            try self.init(
                databaseWriter,
                request: SQLRequest(sql, arguments: arguments, adapter: adapter).bound(to: Fetched.self),
                queue: queue,
                unwrap: { $0.unwrap() },
                itemsAreIdentical: { isSameElement($0.unwrap(), $1.unwrap()) })
        }
        
        /// Creates a fetched records controller initialized from a fetch request
        /// from the [Query Interface](https://github.com/groue/GRDB.swift#the-query-interface).
        ///
        ///     let request = Wine.order(Column("name"))
        ///     let controller = FetchedCollection<Wine>(
        ///         dbQueue,
        ///         request: request,
        ///         isSameElement: { (wine1, wine2) in wine1.id == wine2.id })
        ///
        /// - parameters:
        ///     - databaseWriter: A DatabaseWriter (DatabaseQueue, or DatabasePool)
        ///     - request: A fetch request.
        ///     - queue: Optional dispatch queue (defaults to the main queue)
        ///
        ///         The fetched records controller delegate will be notified of
        ///         record changes in this queue. The controller itself must be used
        ///         from this queue.
        ///
        ///         This dispatch queue must be serial.
        ///
        ///     - isSameElement: Optional function that compares two records.
        ///
        ///         This function should return true if the two records have the
        ///         same identity. For example, they have the same id.
        public convenience init<Request>(
            _ databaseWriter: DatabaseWriter,
            request: Request,
            queue: DispatchQueue = .main,
            isSameElement: @escaping (Fetched, Fetched) -> Bool) throws
            where Request: TypedRequest, Request.Fetched == Fetched
        {
            try self.init(
                databaseWriter,
                request: request,
                queue: queue,
                unwrap: { $0.unwrap() },
                itemsAreIdentical: { isSameElement($0.unwrap(), $1.unwrap()) })
        }
    }
    
    extension FetchedCollection where Fetched: RowConvertible & TableMapping {
        
        // MARK: - Initialization
        
        /// Creates a fetched records controller initialized from a SQL query and
        /// its eventual arguments.
        ///
        ///     let controller = FetchedCollection<Wine>(
        ///         dbQueue,
        ///         sql: "SELECT * FROM wines WHERE color = ? ORDER BY name",
        ///         arguments: [Color.red],
        ///         compareRecordsByPrimaryKey: true)
        ///
        /// - parameters:
        ///     - databaseWriter: A DatabaseWriter (DatabaseQueue, or DatabasePool)
        ///     - sql: An SQL query.
        ///     - arguments: Optional statement arguments.
        ///     - adapter: Optional RowAdapter
        ///     - queue: Optional dispatch queue (defaults to the main queue)
        ///
        ///         The fetched records controller delegate will be notified of
        ///         record changes in this queue. The controller itself must be used
        ///         from this queue.
        ///
        ///         This dispatch queue must be serial.
        ///
        ///     - compareRecordsByPrimaryKey: A boolean that tells if two records
        ///         share the same identity if they share the same primay key.
        public convenience init(
            _ databaseWriter: DatabaseWriter,
            sql: String,
            arguments: StatementArguments? = nil,
            adapter: RowAdapter? = nil,
            queue: DispatchQueue = .main) throws
        {
            let rowComparator = try databaseWriter.read { db in try Fetched.primaryKeyRowComparator(db) }
            try self.init(
                databaseWriter,
                request: SQLRequest(sql, arguments: arguments, adapter: adapter).bound(to: Fetched.self),
                queue: queue,
                unwrap: { $0.unwrap() },
                itemsAreIdentical: { rowComparator($0.row, $1.row) })
        }
        
        /// Creates a fetched records controller initialized from a fetch request.
        /// from the [Query Interface](https://github.com/groue/GRDB.swift#the-query-interface).
        ///
        ///     let request = Wine.order(Column("name"))
        ///     let controller = FetchedCollection<Wine>(
        ///         dbQueue,
        ///         request: request,
        ///         compareRecordsByPrimaryKey: true)
        ///
        /// - parameters:
        ///     - databaseWriter: A DatabaseWriter (DatabaseQueue, or DatabasePool)
        ///     - request: A fetch request.
        ///     - queue: Optional dispatch queue (defaults to the main queue)
        ///
        ///         The fetched records controller delegate will be notified of
        ///         record changes in this queue. The controller itself must be used
        ///         from this queue.
        ///
        ///         This dispatch queue must be serial.
        ///
        ///     - compareRecordsByPrimaryKey: A boolean that tells if two records
        ///         share the same identity if they share the same primay key.
        public convenience init<Request>(
            _ databaseWriter: DatabaseWriter,
            request: Request,
            queue: DispatchQueue = .main) throws
            where Request: TypedRequest, Request.Fetched == Fetched
        {
            let rowComparator = try databaseWriter.read { db in try Fetched.primaryKeyRowComparator(db) }
            try self.init(
                databaseWriter,
                request: request,
                queue: queue,
                unwrap: { $0.unwrap() },
                itemsAreIdentical: { rowComparator($0.row, $1.row) })
        }
    }
#endif