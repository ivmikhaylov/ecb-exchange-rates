package beUtils

import (
	"io/ioutil"
	"log"
	"net/http"
)

func ReadHttpBody(u string) ([]byte, error) {

	r, e1 := http.Get(u)
	if e1 != nil {
		log.Printf("Http.Get failed, %q", e1)
		return nil, e1
	}

	b, e2 := ioutil.ReadAll(r.Body)
	if e2 != nil {
		log.Printf("Failed reading Http body, %q", e2)
		return nil, e2
	}

	return b, nil
}
