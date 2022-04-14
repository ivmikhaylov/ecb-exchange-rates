package beUtils

import (
	"fmt"
	"log"
	"regexp"
	"time"
)

func isValidUrlParDate(dt, n, f string) (m string, ok bool) {

	if len(dt) < 1 {
		m = fmt.Sprintf("URL parameter %s is missing. ", n) +
			fmt.Sprintf("It should be %s=YYYYMMDD", n)
		return m, false
	}

	ok, _ = regexp.MatchString("[0-9]{8}", dt)
	if !ok {
		m = fmt.Sprintf("URL parameter %s should contain only 8 numbers"+
			"from 0-9. For example, %s=20220331", n, n)
		return m, false
	}

	_, e := time.Parse(f, dt)
	if e != nil {
		m = fmt.Sprintf("URL parameter %s should be a valid date", n)
		log.Printf("%s", m)
		return m, false
	}

	return "", true
}
