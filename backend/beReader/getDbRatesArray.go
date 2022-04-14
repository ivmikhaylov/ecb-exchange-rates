package beReader

import (
	"log"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func getDbRatesArray(q string) (d DbManyRates, e error) {

	if len(q) < 1 {
		log.Printf("Empty query")
		return nil, errNotValid
	}

	j, e1 := getDbRatesJson(q)
	if e1 != nil {
		log.Printf("getDbRatesJson failed: %q, %q, %q", q, j, e1)
		return nil, e1
	}

	if j == msgNoRatesJson {
		log.Printf("No rates: %q", j)
		return nil, errNoRates
	}

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
