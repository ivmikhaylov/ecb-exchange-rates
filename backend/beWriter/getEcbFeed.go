package beWriter

import (
	"bytes"
	"encoding/xml"
	"log"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
	"golang.org/x/net/html/charset"
)

// Get ECB exchange rate feeds, either from EC_RSS type or ECB_CRates type.

func getEcbFeed(r interface{}, u string) error {

	b, e1 := beUtils.ReadHttpBody(u)
	if e1 != nil {
		log.Printf("Failed reading Http body, %q", e1)
		return e1
	}

	nr := bytes.NewReader(b)
	decoder := xml.NewDecoder(nr)
	decoder.CharsetReader = charset.NewReaderLabel

	e2 := decoder.Decode(&r)
	if e2 != nil {
		log.Printf("Failed decoding xml, %q", e2)
		return e2
	}

	return nil
}
