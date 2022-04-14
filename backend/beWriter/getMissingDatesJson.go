package beWriter

import (
	"log"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func getMissingDatesJson() (j string, err error) {

	q := "SELECT get_missing_dates_json()"

	j, e1 := beUtils.ReadDbJson(usrName, pwdFile, q)

	if e1 != nil {
		log.Printf("ReadDbJson failed: %q, %q, %q, %q",
			usrName, pwdFile, q, e1)
		return "", e1
	}

	if len(j) < 1 {
		log.Printf("jsonResp is empty: %q", j)
		return "", errEmpty
	}

	if j == msgNoMissingJson {
		return "", errNoMissing
	}

	return j, nil
}
