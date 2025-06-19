import java.io.IOException;
import java.util.StringTokenizer;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class CovidTweetAnalysis {

    public static class TweetAnalysisMapper
            extends Mapper<LongWritable, Text, Text, IntWritable> {

        private final static IntWritable one = new IntWritable(1);
        private Text category = new Text();

        public void map(LongWritable key, Text value, Context context)
                throws IOException, InterruptedException {
            
            // Ignorer la première ligne (header)
            if (key.get() == 0) return;
            
            String line = value.toString();
            
            // Parsing CSV avec gestion des guillemets
            String[] fields = parseCSVLine(line);
            
            // Vérifier qu'on a suffisamment de colonnes
            if (fields.length < 10) return;
            
            // Colonnes du dataset COVID-19 tweets:
            // 0:user_name, 1:user_location, 2:user_description, 3:user_created, 
            // 4:user_followers, 5:user_friends, 6:user_favourites, 7:user_verified, 
            // 8:date, 9:text, 10:hashtags, 11:source, 12:is_retweet
            
            String tweetText = fields[9].toLowerCase(); // colonne 'text'
            String hashtags = fields.length > 10 ? fields[10] : "";
            String isRetweet = fields.length > 12 ? fields[12] : "False";
            String userVerified = fields[7];
            
            // Compter le nombre total de tweets
            category.set("TOTAL_TWEETS");
            context.write(category, one);
            
            // Analyser les hashtags COVID spécifiques
            if (tweetText.contains("#covid19") || tweetText.contains("#covid-19") || 
                hashtags.toLowerCase().contains("covid19")) {
                category.set("HASHTAG_COVID19");
                context.write(category, one);
            }
            
            if (tweetText.contains("#coronavirus") || hashtags.toLowerCase().contains("coronavirus")) {
                category.set("HASHTAG_CORONAVIRUS");
                context.write(category, one);
            }
            
            if (tweetText.contains("#pandemic") || hashtags.toLowerCase().contains("pandemic")) {
                category.set("HASHTAG_PANDEMIC");
                context.write(category, one);
            }
            
            if (tweetText.contains("#lockdown") || hashtags.toLowerCase().contains("lockdown")) {
                category.set("HASHTAG_LOCKDOWN");
                context.write(category, one);
            }
            
            // Analyser les mentions de mots-clés importants
            if (tweetText.contains("vaccine") || tweetText.contains("vaccination")) {
                category.set("KEYWORD_VACCINE");
                context.write(category, one);
            }
            
            if (tweetText.contains("mask") || tweetText.contains("masks")) {
                category.set("KEYWORD_MASK");
                context.write(category, one);
            }
            
            if (tweetText.contains("hospital") || tweetText.contains("icu")) {
                category.set("KEYWORD_HOSPITAL");
                context.write(category, one);
            }
            
            // Analyser les retweets
            if (isRetweet.equalsIgnoreCase("True") || tweetText.startsWith("rt ")) {
                category.set("RETWEETS");
                context.write(category, one);
            }
            
            // Analyser les comptes vérifiés
            if (userVerified.equalsIgnoreCase("True")) {
                category.set("VERIFIED_USERS");
                context.write(category, one);
            }
        }
        
        // Méthode pour parser les lignes CSV avec gestion des guillemets
        private String[] parseCSVLine(String line) {
            return line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)", -1);
        }
    }

    public static class IntSumReducer
            extends Reducer<Text, IntWritable, Text, IntWritable> {
        private IntWritable result = new IntWritable();

        public void reduce(Text key, Iterable<IntWritable> values,
                          Context context) throws IOException, InterruptedException {
            int sum = 0;
            for (IntWritable val : values) {
                sum += val.get();
            }
            result.set(sum);
            context.write(key, result);
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "covid tweet analysis");
        job.setJarByClass(CovidTweetAnalysis.class);
        job.setMapperClass(TweetAnalysisMapper.class);
        job.setCombinerClass(IntSumReducer.class);
        job.setReducerClass(IntSumReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
