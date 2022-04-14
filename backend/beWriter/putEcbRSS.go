package beWriter

import (
	"log"
)

func putEcbRSSrates() error {

	d := EcbRSS{}

	e1 := getEcbFeed(&d, rssLink)
	if e1 != nil {
		log.Printf("getEcbFeed failed, %q, %q", rssLink, e1)
		return e1
	}

	// No link "" to store for RSS
	// No queryDate "" to replace for RSS
	e2 := putDbJsonPubs(d, "", "")
	if e2 != nil {
		log.Printf("putDbJsonPubs failed, %q", e2)
		return e2
	}

	e3 := putDbJsonRates(d, "")
	if e3 != nil {
		log.Printf("putDbJsonRates failed, %q", e3)
		return e3
	}

	return nil
}
