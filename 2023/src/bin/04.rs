advent_of_code::solution!(4);

struct LineDimensions {
    win_start: usize,
    win_stop: usize,
    num_start: usize,
    num_stop: usize,
}

#[derive(Debug)]
struct Card {
    common: u8,
}

fn parse_dims(line: &[u8]) -> LineDimensions {
    let mut i = 0usize;
    while line[i] != b':' {
        i += 1;
    }

    let win_start = i + 2;

    while line[i] != b'|' {
        i += 1;
    }

    let win_stop = i - 3;

    let num_start = i + 2;
    let num_stop = line.len() - 2;

    LineDimensions { win_start, win_stop, num_start, num_stop }
}

fn parse_card(dims: &LineDimensions, line: &[u8]) -> Card {
    let mut winning = [0u8; 100];

    for i in (dims.win_start..=dims.win_stop).step_by(3) {
        let mut num = 0;

        if line[i] != b' ' {
            num += 10 * (line[i] - b'0');
        }

        num += line[i + 1] - b'0';

        winning[num as usize] = num;
    }

    let mut common = 0u8;

    for i in (dims.num_start..=dims.num_stop).step_by(3) {
        let mut num = 0;

        if line[i] != b' ' {
            num += 10 * (line[i] - b'0');
        }

        num += line[i + 1] - b'0';

        if winning[num as usize] != 0 { common += 1; }
    }

    Card { common }
}

pub fn part_one(input: &str) -> Option<u32> {
    let first_line = input.lines().next().unwrap().as_bytes();
    let dims = &parse_dims(first_line);

    let mut result = 0;

    for line in input.lines() {
        let card = parse_card(dims, line.as_bytes());

        if card.common > 0 {
            result += 1 << (card.common - 1);
        }
    }

    Some(result)
}

pub fn part_two(input: &str) -> Option<u32> {
    let first_line = input.lines().next().unwrap().as_bytes();
    let dims = parse_dims(first_line);

    let mut cards: Vec<Card> = Vec::new();

    for line in input.lines() {
        cards.push(parse_card(&dims, line.as_bytes()));
    }

    let mut counts = vec![1u32; cards.len()];
    let mut result = 0;

    for (i, card) in cards.iter().enumerate() {
        if card.common > 0 {
            for j in i + 1..=i + (card.common as usize) {
                counts[j] += counts[i];
            }
        }

        result += counts[i];
    }

    Some(result)
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
        assert_eq!(result, Some(30));
    }
}
