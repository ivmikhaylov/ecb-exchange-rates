package beUtils

import (
	"fmt"
	"io/ioutil"
	"log"
)

func getPwdFromFile(fn string) ([]byte, error) {

	logSuffix := fmt.Sprintf("Reading a password from file %q:", fn)

	s, e := ioutil.ReadFile(fn)
	if e != nil {
		log.Printf("%s %q", logSuffix, e)
		return nil, e
	}

	return s, e
}
