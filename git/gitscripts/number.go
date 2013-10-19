package main

import (
	"bytes"
	"encoding/binary"
	"encoding/hex"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"strings"
)

func git_output(name string, arg ...string) io.ReadCloser {
	cmd := exec.Command("git", append([]string{name}, arg...)...)
	out, err := cmd.StdoutPipe()
	if err != nil {
		log.Fatal(err)
	}

	err = cmd.Start()
	if err != nil {
		log.Fatal(err)
	}

	return out
}

type Line struct {
	Hash  [20]byte
	Count uint32
}

func main() {
	target := "HEAD"

	if len(os.Args) < 2 {
		target = os.Args[1]
	}

	reader := git_output("rev-parse", target)
	out, err := ioutil.ReadAll(reader)
	if err != nil {
		log.Fatal(err)
	}

	hash := strings.TrimSpace(string(out))

	squished, err := hex.DecodeString(hash)
	if err != nil {
		log.Fatal(err)
	}

	reader = git_output("cat-file", "blob", "refs/number/commits:"+hash[:2])

	var line Line
	for {
		err = binary.Read(reader, binary.BigEndian, &line)
		if err != nil {
			break
		}
		if bytes.Equal(line.Hash[:], squished) {
			fmt.Println(line.Count)
			break
		}
	}
}
