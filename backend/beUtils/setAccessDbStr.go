package beUtils

import (
	"fmt"
	"strconv"
)

func setAccessDbStr(u, s string, p int, db string) string {

	return fmt.Sprintf("%s:%s@tcp(db:%s)/%s", u, s, strconv.Itoa(p), db)
}
