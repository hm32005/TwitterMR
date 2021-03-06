package tagcoocc.stripes;

import java.io.IOException;
import java.util.Iterator;
import java.util.Map.Entry;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.MapWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapreduce.Reducer;

public class StripesHashTagCoOccReducer extends
		Reducer<Text, MapWritable, Text, Text> {
	private MapWritable result;

	public void reduce(Text key, Iterable<MapWritable> values, Context context)
			throws IOException, InterruptedException {
		result = new MapWritable();
		Iterator<MapWritable> iter = values.iterator();

		while (iter.hasNext()) {
			for (Entry<Writable, Writable> e : iter.next().entrySet()) {
				Writable inner_key = e.getKey();
				IntWritable fromCount = (IntWritable) e.getValue();
				if (result.containsKey(inner_key)) {
					IntWritable count = (IntWritable) result.get(inner_key);
					count.set(count.get() + fromCount.get());
				} else {
					result.put(inner_key, fromCount);
				}
			}
		}
		StringBuffer value = new StringBuffer();
		for (Entry<Writable, Writable> e : result.entrySet()) {
			Writable key2 = e.getKey();
			Writable value2 = e.getValue();
			String appended = key2.toString() + ", " + value2.toString() + "; ";
			value.append(appended);
		}
		context.write(key, new Text(value.toString()));
	}

}
