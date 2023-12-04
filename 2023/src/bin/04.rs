advent_of_code::solution!(4);

pub fn part_one(input: &str) -> Option<u32> {
    let first_line = input.lines().next().unwrap().as_bytes();

    let mut i = 0usize;
    while first_line[i] != b':' {
        i += 1;
    }

    let win_start = i + 2;

    while first_line[i] != b'|' {
        i += 1;
    }

    let win_stop = i - 3;

    let num_start = i + 2;
    let num_end = first_line.len() - 2;

    let mut result = 0;

    for line in input.lines() {
        let line = line.as_bytes();
        let mut table = [0u8; 100];

        for i in (win_start..=win_stop).step_by(3) {
            let mut num = 0;

            if line[i] != b' ' {
                num += 10 * (line[i] - b'0');
            }

            num += line[i + 1] - b'0';

            table[num as usize] = num;
        }

        let mut score = 1;

        for i in (num_start..=num_end).step_by(3) {
            let mut num = 0;

            if line[i] != b' ' {
                num += 10 * (line[i] - b'0');
            }

            num += line[i + 1] - b'0';

            if table[num as usize] != 0 { score *= 2; }
        }

        result += score / 2;
    }

    Some(result)
}

pub fn part_two(input: &str) -> Option<u32> {
    None
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let result = part_one(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(13));
    }

    #[test]
    fn test_part_two() {
        let result = part_two(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, None);
    }
}
