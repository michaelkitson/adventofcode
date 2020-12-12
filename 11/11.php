<?php
class SeatingArea {
    const DIRECTIONS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]];

    public function __construct($state, $threshold, $max_dist) {
        $this->state = $state;
        $this->threshold = $threshold;
        $this->max_dist = $max_dist;
        $this->height = count($state);
        $this->width = strlen($state[0]);
    }

    public function get_cell($y, $x): ?string {
        $out_of_bounds = $y < 0 || $x < 0 || $y >= $this->height || $x >= $this->width;
        return $out_of_bounds ? null : $this->state[$y][$x];
    }

    public function count_neighbors($y, $x): int {
        $count = 0;
        foreach (self::DIRECTIONS as list($y_diff, $x_diff)) {
            for ($dist = 1; $dist <= $this->max_dist; $dist++) {
                $seat = $this->get_cell($y + $y_diff * $dist, $x + $x_diff * $dist);
                $count += $seat === '#' ? 1 : 0;
                if ($seat !== '.') {
                    break;
                }
            }
        }
        return $count;
    }

    public function tick(): void {
        $next = [];
        foreach ($this->state as $y => $line) {
            $next_line = '';
            foreach (str_split($line) as $x => $char) {
                $n = $this->count_neighbors($y, $x);
                if ($char === 'L' && $n === 0) {
                    $next_line .= '#';
                } else if ($char === '#' && $n >= $this->threshold) {
                    $next_line .= 'L';
                } else {
                    $next_line .= $char;
                }
            }
            $next[] = $next_line;
        }
        $this->state = $next;
    }

    public function tick_until_settled(): void {
        do {
            $prev = $this->state;
            $this->tick();
            $current = $this->state;
        } while ($prev != $current);
    }

    public function count_occupied_seats(): int {
        return substr_count(implode('', $this->state), '#');
    }
}

$state = explode("\n", file_get_contents('./input.txt'));
array_pop($state); // drop trailing empty line
$seating_area = new SeatingArea($state, 4, 1);
$seating_area->tick_until_settled();
print("Part 1: {$seating_area->count_occupied_seats()}\n");
$seating_area = new SeatingArea($state, 5, PHP_INT_MAX);
$seating_area->tick_until_settled();
print("Part 2: {$seating_area->count_occupied_seats()}\n");
