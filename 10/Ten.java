import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;

public class Ten {
  public static long arrangements(long runningOnes) {
    if (runningOnes < 4) { return 1 << (runningOnes - 1); }
    if (runningOnes == 4) { return 7; }
    return 13 * (1 << (runningOnes - 5));
  }

  public static void main(String[] args) throws IOException {
    BufferedReader reader = new BufferedReader(new FileReader("input.txt"));
    ArrayList<Integer> numbers = new ArrayList<Integer>();
    String line;
    while ((line = reader.readLine()) != null) {
      numbers.add(Integer.parseInt(line));
    }
    numbers.add(0);
    Collections.sort(numbers);
    numbers.add(numbers.get(numbers.size() - 1) + 3);

    int ones = 0;
    int threes = 0;
    long runningOnes = 0;
    long arrangements = 1;
    for (int i = 0; i < numbers.size() - 1; i++) {
      int diff = numbers.get(i + 1) - numbers.get(i);
      if (diff == 3) {
        threes += 1;
        if (runningOnes > 1) {
          arrangements *= Ten.arrangements(runningOnes);
        }
        runningOnes = 0;
      }
      if (diff == 1) {
        ones += 1;
        runningOnes += 1;
      }
    }
    System.out.println("Part 1: " + ones * threes);
    System.out.println("Part 2: " + arrangements);
  }
}
