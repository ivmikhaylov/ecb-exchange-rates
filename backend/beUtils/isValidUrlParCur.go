package beUtils

import (
	"fmt"
	"regexp"
)

func isValidUrlParCur(c, n string) (m string, ok bool) {

	if len(c) < 1 {
		m = fmt.Sprintf("URL parameter %s is missing.\n", n) +
			fmt.Sprintf("It should be %s=NNN", n)
		return m, false
	}

	ok, _ = regexp.MatchString("[A-Z]{3}", c)
	if !ok {
		m = fmt.Sprintf("URL parameter %s should contain only 3 capital letters"+
			"from A-Z. For example, %s=USD", n, n)
		return m, false
	}

	return "", true
}
