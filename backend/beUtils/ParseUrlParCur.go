package beUtils

import (
	_ "github.com/go-sql-driver/mysql"
)

func ParseUrlParCur(c0, nc string) (c1, m string, e error) {

	m, ok := isValidUrlParCur(c0, nc)
	if !ok {
		return "", m, errNotValid
	}

	/* ideas of further development:
	- currencies are introduced and phased out
	- add parsing from the "golang.org/x/text/currency" module
	to check the validity of the given currency for a elected period  */

	return c0, "", nil
}
