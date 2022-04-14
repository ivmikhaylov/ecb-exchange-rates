package beUtils

import (
	"fmt"
	"log"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

func ParseUrlParDate(d0, n, f0, f1 string) (d1, m string, e error) {

	m, ok := isValidUrlParDate(d0, n, f0)
	if !ok {
		return "", m, errNotValid
	}

	dt, e := time.Parse(f0, d0)
	if e != nil {
		m = fmt.Sprintf("URL parameter %q should be a valid date.", n)
		log.Printf("time.Parse failed %q, %q, %q", d0, f0, e)
		return "", m, e
	}

	var (
		dm, _ = time.Parse(dateTimeFmt, minDateStr)
		dn    = time.Now()
	)

	if dt.Before(dm) {
		return dm.Format(f1), "", nil
	}

	if dt.After(dn) {
		return dn.Format(f1), "", nil
	}

	return dt.Format(f1), "", nil
}
