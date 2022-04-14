package beWriter

import (
	"log"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func getMissingDatesArray() (d DbGetMissingDates, err error) {

	q := "SELECT get_missing_dates_json()"

	j, e1 := beUtils.ReadDbJson(usrName, pwdFile, q)

	if e1 != nil {
		log.Printf("ReadDbJson failed: %q, %q, %q, %q",
			usrName, pwdFile, q, e1)
		return nil, e1
	}

	if len(j) < 1 {
		log.Printf("jsonResp is empty: %q", j)
		return nil, errEmpty
	}

	if j == msgNoMissingJson {
		return nil, errNoMissing
	}

	// Parsing with the type agnostinc DataResp interface{}
	e2 := beUtils.ParseJson(j, &d)
	if e2 != nil {
		log.Printf("ParseJson failed: %q, %q, %q", j, d, e2)
		return nil, e2
	}

	if len(d) < 1 {
		log.Printf("DataResp is empty: %q", d)
		return nil, errEmpty
	}

	return d, nil
}
