package beWriter

import (
	"log"
	"sync"
)

func putMissingDates() error {

	d, e1 := getMissingDatesArray()

	if e1 == errNoMissing {
		return errNoMissing
	}

	if e1 != nil {
		log.Printf("getMissingDates failed: %q", e1)
		return e1
	}

	if len(d) < 1 {
		return errEmpty
	}

	var (
		wg sync.WaitGroup
		e2 error
	)

	for _, v := range d {

		wg.Add(1)

		go func(dt string) {

			defer wg.Done()

			e2 = putEcbCRates(dt)
			if e2 != nil {
				log.Printf("putEcbCRates failed: %q, %q", dt, e2)
				return
			}
		}(v)
	}

	if e2 != nil {
		return e2
	}

	wg.Wait()

	return nil
}
