package beWriter

import (
	"encoding/json"
	"fmt"
	"log"
	"strings"
	"time"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func putDbJsonRates(d interface{}, dt string) error {

	rm := ManyRates{}

	switch d.(type) {
	case EcbCRates:

		for _, re1 := range d.(EcbCRates).Currencies.Currency {
			rs := SingleRate{
				PUB_DATETIME: dt, // As Ecb responces with a previous bank day
				CUR_CODE:     re1.ID,
				EVENING_RATE: re1.Rate,
			}
			rm = append(rm, rs)
		}

	case EcbRSS:
		for _, re2 := range d.(EcbRSS).Channel.Item {

			// Mon, 2 Jan 2006 15:04:05 -0700 to 2006-01-02
			dp, e1 := time.Parse(timeLongFmt, re2.PubDate)
			if e1 != nil {
				log.Printf("EcbCRates time.Parse failed: %q, %q, %q",
					timeLongFmt, re2.PubDate, e1)
				return e1
			}
			df := dp.Format(dateFmt)

			words := strings.Fields(re2.Description.Rates)

			for len(words) > 0 {
				rs := SingleRate{
					PUB_DATETIME: df,
					CUR_CODE:     words[0],
					EVENING_RATE: words[1],
				}
				words = words[2:]
				rm = append(rm, rs)
			}
		}

	default:
		log.Printf("putJsonPubs failed: %q", errEcbType)
		return errEcbType
	}

	if len(rm) == 0 {
		log.Print("Empty rates")
		return errEmpty
	}

	j, e2 := json.Marshal(rm)
	if e2 != nil {
		log.Printf("Rates json.Marshal failed: %q", e2)
		return e2
	}

	if len(j) < 1 {
		log.Print("Empty Json")
		return errEmpty
	}

	q := fmt.Sprintf("SELECT put_rates_json('%s')", string(j[:]))

	c, n, e3 := beUtils.CallDbCodeResp(usrName, pwdFile, q)
	if e3 != nil {
		log.Printf("Run CallDbCodeResp failed, %q, %q, %q, %q",
			usrName, pwdFile, q, e3)
		return e3
	}

	if c != "200" {
		log.Printf("putJsonRates: Errors encountered, %q, %q, %q",
			c, n, e3)
		return e3

	}

	return nil
}
