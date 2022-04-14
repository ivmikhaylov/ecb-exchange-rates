package beWriter

import (
	"log"
	"time"
)

func putEcbCRates(dt string) error {

	// 2006-01-02 to 20060102

	dp, e1 := time.Parse(dateFmt, dt)
	if e1 != nil {
		log.Printf("EcbCRates time.Parse failed: %q, %q, %q",
			dateFmt, dt, e1)
		return e1
	}

	var df string = dp.Format(URLtimeFmt)

	u := dayLink + df

	d := EcbCRates{}

	e3 := getEcbFeed(&d, u)
	if e3 != nil {
		log.Printf("dayFeed getEcbFeed failed, %q, %q", u, e3)
		return e3
	}

	e4 := putDbJsonPubs(d, u, dp.Format(dateFmt))
	if e4 != nil {
		log.Printf("dayFeed putPublication failed, %q", e4)
		return e4
	}

	e5 := putDbJsonRates(d, dp.Format(dateFmt))
	if e5 != nil {
		log.Printf("dayFeed putPutRates failed, %q", e5)
		return e5
	}

	return nil

}
