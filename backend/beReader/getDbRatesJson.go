package beReader

import (
	"log"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func getDbRatesJson(q string) (j string, e error) {

	if len(q) < 1 {
		log.Printf("Empty query")
		return "", errNotValid
	}

	j, e = beUtils.ReadDbJson(usrName, pwdFile, q)
	if e != nil {
		log.Printf("ReadDbJson failed: %q, %q, %q, %q",
			usrName, pwdFile, q, e)
		return "", e
	}

	if j == msgNoRatesJson {
		log.Printf("No rates: %q", j)
		return "", errNoRates
	}

	if j == "[]" || j == "" {
		log.Printf("Empty jsonResp")
		return "", errEmpty
	}

	if j == "" {
		log.Printf("jsonResp: No response")
		return "", errEmpty
	}

	return j, nil
}
