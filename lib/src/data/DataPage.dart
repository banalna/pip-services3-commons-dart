/**
 * Data transfer object that is used to pass results of paginated queries.
 * It contains items of retrieved page and optional total number of items.
 * 
 * Most often this object type is used to send responses to paginated queries.
 * Pagination parameters are defined by [[PagingParams]] object.
 * The <code>skip</code> parameter in the PagingParams there means how many items to skip.
 * The <code>takes</code> parameter sets number of items to return in the page.
 * And the optional <code>total</code> parameter tells to return total number of items in the query.
 * 
 * Remember: not all implementations support the <code>total</code> parameter
 * because its generation may lead to severe performance implications.
 * 
 * @see [[PagingParams]]
 * 
 * ### Example ###
 * 
 * page = myDataClient.getDataByFilter(
 *   "123",
 *   FilterParams.fromTuples("completed": true),
 *   NewPagingParams(0, 100, true)
 * );
 *
 * for (item in page.Data) {
 *       print(item);
 *  }
 */
class DataPage<T> {
  /** The items of the retrieved page. */
  List<T> data;

  /** The total amount of items in a request. */
  int total;

  /**
     * Creates a new instance of data page and assigns its values.
     * 
     * @param data      a list of items from the retrieved page.
     * @param total     (optional) .
     */
  DataPage(List<T> data, int total) {
    this.total = total;
    this.data = data;
  }
  factory DataPage.fromJson(Map<String, dynamic> json, Function fromJson) {
    //final items = json['data'].cast<Map<String, dynamic>>();
    final items = json['data'];

    return new DataPage<T>(
        new List<T>.from(items.map((itemsJson) => fromJson(itemsJson))),
        json['total']);
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'total': this.total, 'data': this.data};
}
