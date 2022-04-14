package beUtils

import (
	"encoding/json"
	"io"
	"log"
)

func ParseApiRequest(rb io.ReadCloser) (ra ApiRequest, e error) {

	decoder := json.NewDecoder(rb)

	e = decoder.Decode(&ra)
	if e != nil {
		log.Printf("json.NewDecoder failed: %q", e)
		return ra, e
	}

	return ra, nil
}
