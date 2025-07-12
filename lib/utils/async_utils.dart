class AsyncUtils{
  static Future<List<Output>> withBatchLimit<Input, Output>({
    required List<Input> itemList,
    required Future<Output> Function(Input item) mapper,
    int batchSize = 5,
  }) async {
    final List<Output> result = [];

    for(int i = 0; i < itemList.length; i += batchSize){
      final batch = itemList.skip(i).take(batchSize);
      final batchResult = await Future.wait(batch.map(mapper));
      result.addAll(batchResult);
    }

    return result;
  }
}