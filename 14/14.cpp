#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <vector>

#define BIT_SET(a, b) ((a) |= (1ULL << (b)))
#define BIT_CLEAR(a, b) ((a) &= ~(1ULL << (b)))
#define BIT_FLIP(a, b) ((a) ^= (1ULL << (b)))
#define BIT_CHECK(a, b) (!!((a) & (1ULL << (b))))

using namespace std;
class DockingMemory {
public:
    string mask;
    map<long long, long long> memory1;
    map<long long, long long> memory2;

    void set_mask(string new_mask) {
        std::reverse(new_mask.begin(), new_mask.end());
        mask = new_mask;
    }

    void set(long long location, long long value) {
        long long masked_value = value;
        for (int i = 0; i < 36; i++) {
            if (mask[i] != 'X') {
                bool mask_value = mask[i] == '1';
                if (mask_value != BIT_CHECK(masked_value, i)) {
                    BIT_FLIP(masked_value, i);
                }
            }
        }
        memory1[location] = masked_value;

        vector<int> x_locations;
        long long masked_location = location;
        for (int i = 0; i < 36; i++) {
            if (mask[i] != '0') { // If mask is 1, set to 1, if mask is X, set to 0
                bool mask_value = mask[i] == '1';
                if (mask_value != BIT_CHECK(masked_location, i)) {
                    BIT_FLIP(masked_location, i);
                }
            }
            if (mask[i] == 'X') {
                x_locations.push_back(i);
            }
        }
        int permutations = 1 << x_locations.size();
        for (int i = 0; i < permutations; i++) {
            long long permuted_location = masked_location;
            for (int j = 0; j < x_locations.size(); j++) {
                if (BIT_CHECK(i, j)) {
                    BIT_SET(permuted_location, x_locations[j]);
                } else {
                    BIT_CLEAR(permuted_location, x_locations[j]);
                }
            }
            memory2[permuted_location] = value;
        }
    }

    long long sum1() {
        return memory_sum(memory1);
    };

    long long sum2() {
        return memory_sum(memory2);
    };

private:
    long long memory_sum(map<long long, long long> &memory) {
        long long sum = 0;
        for (auto &it : memory) {
            sum += it.second;
        }
        return sum;
    }
};

int main() {
    DockingMemory memory;
    ifstream file;
    file.open("input.txt", ios::in);
    string line;
    while (getline(file, line)) {
        if (line.starts_with("mask = ")) {
            memory.set_mask(line.substr(7));
        } else {
            long long location = stoll(line.substr(line.find('[') + 1, line.find(']')));
            long long value = stoll(line.substr(line.find(']') + 4));
            memory.set(location, value);
        }
    }
    file.close();
    cout << "Part 1: " << memory.sum1() << endl;
    cout << "Part 2: " << memory.sum2() << endl;
    return 0;
};