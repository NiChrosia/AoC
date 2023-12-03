use std::cmp;

advent_of_code::solution!(2);

pub fn part_one(input: &str) -> Option<u32> {
    let mut result = 0u32;

    for (i, line) in input.lines().enumerate() {
        'rolls: {
            for roll in line.split(": ").last().unwrap().split("; ") {
                for cubes in roll.split(", ") {
                    let mut parts = cubes.split(" ");

                    let count = parts.next().unwrap().parse::<u32>().unwrap();
                    let kind = parts.last().unwrap();

                    match kind {
                        "red" => if count > 12 { break 'rolls },
                        "green" => if count > 13 { break 'rolls },
                        "blue" => if count > 14 { break 'rolls },
                        _ => (),
                    }
                }
            }

            result += (i + 1) as u32;
        }
    }

    Some(result)
}

pub fn part_two(input: &str) -> Option<u32> {
    let mut result = 0u32;

    for line in input.lines() {
        let mut max_r = 0u32;
        let mut max_g = 0u32;
        let mut max_b = 0u32;

        for roll in line.split(": ").last().unwrap().split("; ") {
            for cubes in roll.split(", ") {
                let mut parts = cubes.split(" ");

                let count = parts.next().unwrap().parse::<u32>().unwrap();
                let kind = parts.last().unwrap();

                match kind {
                    "red" => max_r = cmp::max(max_r, count),
                    "green" => max_g = cmp::max(max_g, count),
                    "blue" => max_b = cmp::max(max_b, count),
                    _ => (),
                }
            }
        }

        result += max_r * max_g * max_b;
    }

    Some(result)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let result = part_one(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(8));
    }

    #[test]
    fn test_part_two() {
        let result = part_two(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(2286));
    }
}
