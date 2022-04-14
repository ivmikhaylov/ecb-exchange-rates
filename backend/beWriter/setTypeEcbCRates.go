package beWriter

import (
	"encoding/xml"
)

type EcbCRates struct {
	XMLName     xml.Name `xml:"CRates"`
	Schema      string   `xml:",chardata"`
	Xmlns       string   `xml:"xmlns,attr"`
	Default     string   `xml:"default,attr"`
	DC          string   `xml:"dc,attr"`
	XSI         string   `xml:"xsi,attr"`
	SL          string   `xml:"schemaLocation,attr"`
	Description string   `xml:"description,attr"`
	Source      string   `xml:"source,attr"`
	Date        string   `xml:"Date"`
	Currencies  struct {
		Currency []struct {
			ID   string `xml:"ID"`
			Rate string `xml:"Rate"`
		} `xml:"Currency"`
	} `xml:"Currencies"`
}
