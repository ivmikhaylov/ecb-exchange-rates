package beUtils

import (
	"fmt"
	"log"
)

func GetRespVal(j string) (c, n string, e error) {

	if len(j) < 1 {
		log.Printf("Empty jsonResp")
		return "", "", errEmpty
	}

	d := DbGetLongStatus{}

	// Parsing with the type agnostinc DataResp interface{}
	e = ParseJson(j, &d)
	if e != nil {
		log.Printf("ParseJson failed: %q, %q, %q", j, d, e)
		return "", "", e
	}

	var r []string
	for k, v := range d {
		r = append(r, fmt.Sprint(k))
		r = append(r, fmt.Sprint(v))
	}

	return r[0], r[1], nil

}
