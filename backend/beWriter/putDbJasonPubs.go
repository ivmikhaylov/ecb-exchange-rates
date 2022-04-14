package beWriter

import (
	"encoding/json"
	"fmt"
	"log"
	"time"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func putDbJsonPubs(d interface{}, u string, dt string) error {

	pm := ManyPublications{}

	switch d.(type) {
	case EcbCRates:

		ps := singlePublication{
			PUB_DATETIME: dt, // As Ecb responces with a previous bank day
			PUB_TITLE:    "", // d.(EcbCRates).Description
			PUB_LINK:     "", // d.(EcbCRates).Source
			PUB_GUID:     u,
		}
		pm = append(pm, ps)

	case EcbRSS:
		for _, re := range d.(EcbRSS).Channel.Item {

			// Mon, 2 Jan 2006 15:04:05 -0700 to 2006-01-02
			pd, e1 := time.Parse(timeLongFmt, re.PubDate)
			if e1 != nil {
				log.Printf("EcbCRates time.Parse failed: %q, %q, %q",
					timeLongFmt, re.PubDate, e1)
				return e1
			}
			df := pd.Format(dateFmt)

			ps := singlePublication{
				PUB_DATETIME: df,
				PUB_TITLE:    re.Title,
				PUB_LINK:     "", // re.Link,
				PUB_GUID:     re.Guid.Content,
			}
			pm = append(pm, ps)

		}

	default:
		log.Printf("putEcbRates failed: %q", errEcbType)
		return errEcbType
	}

	if len(pm) == 0 {
		log.Print("Empty pm")
		return errEmpty
	}

	j, e2 := json.Marshal(pm)
	if e2 != nil {
		log.Printf("Pub json.Marshal failed: %q", e2)
		return e2
	}

	if len(j) < 1 {
		log.Print("Empty j")
		return errEmpty
	}

	p := fmt.Sprintf("SELECT put_publication_json('%s')", string(j[:]))

	c, n, e3 := beUtils.CallDbCodeResp(usrName,
		pwdFile, p)
	if e3 != nil {
		log.Printf("Run CallDbCodeResp failed, %q, %q, %q, %q",
			usrName, pwdFile, p, e3)
		return e3
	}

	if c != "200" {
		log.Printf("putJsonpm: Publications: Errors encountered, %q, %q, %q",
			c, n, e3)
		return e3

	}

	return nil
}
