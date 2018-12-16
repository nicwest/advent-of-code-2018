package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

var matcher = regexp.MustCompile("([0-9]+) players; last marble is worth ([0-9]+) points")

func fatal(err error) {
	fmt.Println(err)
	os.Exit(1)
}

type node struct {
	value int
	next  *node
	prev  *node
}

type state struct {
	players int
	last    int
	current *node
	player  int
	scores  map[int]int
}

func newState() (*state, error) {
	reader := bufio.NewReader(os.Stdin)
	text, err := reader.ReadString('\n')
	if err != nil {
		return nil, err
	}

	//text := "9 players; last marble is worth 25 points"

	matches := matcher.FindStringSubmatch(text)
	players, err := strconv.Atoi(matches[1])
	if err != nil {
		return nil, err
	}
	last, err := strconv.Atoi(matches[2])
	if err != nil {
		return nil, err
	}
	zero := node{value: 0}
	zero.next = &zero
	zero.prev = &zero
	s := state{
		players: players,
		last:    last,
		current: &zero,
		player:  1,
		scores:  make(map[int]int),
	}
	return &s, nil
}

func (s *state) add(n int) {
	previous := s.current.next
	next := s.current.next.next
	marble := &node{value: n, prev: previous, next: next}
	previous.next = marble
	next.prev = marble
	s.current = marble
}

func (s *state) take(n int) int {
	target := s.current.prev.prev.prev.prev.prev.prev.prev
	target.prev.next = target.next
	target.next.prev = target.prev
	s.current = target.next
	return target.value + n
}

func main() {
	s, err := newState()
	if err != nil {
		fatal(err)
	}

	for i := 1; i < s.last+1; i++ {
		if i%23 == 0 {
			v := s.take(i)
			s.scores[s.player] = s.scores[s.player] + v
		} else {
			s.add(i)
		}
		if s.player == s.players {
			s.player = 1
		} else {
			s.player++
		}
	}

	best := 0
	player := 0
	for i := 1; i <= s.players; i++ {
		v := s.scores[i]
		if v > best {
			best = v
			player = i
		}
	}
	fmt.Printf("player: %d best: %d", player, best)
}
