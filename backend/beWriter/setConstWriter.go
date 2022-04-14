package beWriter

import (
	"errors"
	"fmt"
)

const (
	usrName      = "writer"
	pwdFile      = "go-password-writer"
	rssLink      = "https://www.bank.lv/vk/ecb_rss.xml"
	dayLink      = "https://www.bank.lv/vk/ecb.xml?date="
	msgEcbType   = "ecbrates: parsed xml type mismatch"
	msgEmpty     = "ecbrates: empty response"
	msgNotValid  = "ecbrates: not valid"
	msgNoMissing = "ecbrates: no missing dates"
	timeLongFmt  = "Mon, 02 Jan 2006 15:04:05 -0700"
	timeShortFmt = "20060102 15:04:05"
	dateTinyFmt  = "20060102"
	dateTimeFmt  = "2006-01-02 15:04:05"
	dateFmt      = "2006-01-02"
	URLtimeFmt   = "20060102"
	minDateStr   = "1999-01-04 16:00:00"
)

var (
	msgNoMissingJson = fmt.Sprintf("[%q]", msgNoMissing)
	errEcbType       = errors.New(msgEcbType)
	errEmpty         = errors.New(msgEmpty)
	errNoMissing     = errors.New(msgNoMissing)
)
