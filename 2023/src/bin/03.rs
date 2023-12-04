use std::str;

advent_of_code::solution!(3);

pub fn part_one(input: &str) -> Option<u32> {
    let map = input.lines().map(|l| l.as_bytes()).collect::<Vec<&[u8]>>();
    let mut table = [0; 1000];

    let width = map[0].len();

    let mut result = 0u32;

    for (y, line) in map.iter().enumerate() {
        for (x, c) in line.iter().enumerate() {
            if matches!(c, b'.' | b'0'..=b'9') { continue; }

            for test_y in y - 1..=y + 1 {
                for test_x in x - 1..=x + 1 {
                    if matches!(&map[test_y][test_x], b'0'..=b'9') {
                        let mut start_x = test_x;

                        while start_x > 0 && matches!(&map[test_y][start_x - 1], b'0'..=b'9') {
                            start_x -= 1;
                        }

                        let mut end_x = test_x;

                        while end_x < width - 1 && matches!(&map[test_y][end_x + 1], b'0'..=b'9') {
                            end_x += 1;
                        }

                        let value = str::from_utf8(&map[test_y][start_x..=end_x]).unwrap().parse::<u32>().unwrap();

                        // this does break with something like
                        //  *      *
                        //  78     78
                        //  *
                        // but I'm fairly certain that doesn't occur in the input data
                        //
                        // the additional +1 is because a number can be in the top-left corner,
                        // giving it a coordinate of (0, 0), or just 0 flattened, which is the
                        // default value, making this checking incorrect. With the +1, however,
                        // every value will be at least 1, eliminating the error
                        if table[value as usize] != start_x + test_y * width + 1 {
                            table[value as usize] = start_x + test_y * width + 1;
                            result += value;
                        }
                    }
                }
            }
        }
    }

    Some(result as u32)
}

pub fn part_two(input: &str) -> Option<u32> {
    let map = input.lines().map(|l| l.as_bytes()).collect::<Vec<&[u8]>>();
    let width = map[0].len();

    let mut result = 0u32;

    for (y, line) in map.iter().enumerate() {
        for (x, c) in line.iter().enumerate() {
            if c != &b'*' { continue; }

            let mut found: Vec<u32> = Vec::new();

            'search: {
                for test_y in y - 1..=y + 1 {
                    for test_x in x - 1..=x + 1 {
                        if matches!(&map[test_y][test_x], b'0'..=b'9') {
                            let mut start_x = test_x;

                            while start_x > 0 && matches!(&map[test_y][start_x - 1], b'0'..=b'9') {
                                start_x -= 1;
                            }

                            let mut end_x = test_x;

                            while end_x < width - 1 && matches!(&map[test_y][end_x + 1], b'0'..=b'9') {
                                end_x += 1;
                            }

                            let value = str::from_utf8(&map[test_y][start_x..=end_x]).unwrap().parse::<u32>().unwrap();

                            if !found.contains(&value) {
                                found.push(value);

                                if found.len() > 2 { break 'search; }
                            }
                        }
                    }
                }

                if found.len() < 2 { break 'search; }

                result += found[0] * found[1];
            }
        }
    }

    Some(result)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let result = part_one(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(4361));
    }

    #[test]
    fn test_part_two() {
        let result = part_two(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(467835));
    }
}
