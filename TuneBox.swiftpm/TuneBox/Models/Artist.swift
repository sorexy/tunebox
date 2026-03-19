struct Artist: Identifiable {
    let id: String  // artist name, lowercased
    let name: String
    var albums: [Album]  // sorted by album title
}
