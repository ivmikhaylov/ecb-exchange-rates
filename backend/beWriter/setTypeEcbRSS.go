package beWriter

import (
	"encoding/xml"
)

type EcbRSS struct {
	XMLName xml.Name `xml:"rss"`
	Version string   `xml:"version,attr"`
	Link    struct {
		Text string `xml:",chardata"`
		Rel  string `xml:"rel,attr"`
		Type string `xml:"type,attr"`
		Href string `xml:"href,attr"`
	} `xml:"link"`
	Channel struct {
		Title       string `xml:"title"`
		Description struct {
			XMLName xml.Name `xml:"description"`
			Text    string   `xml:",chardata"`
		}
		Link          string `xml:"link"`
		LastBuildDate string `xml:"lastBuildDate"`
		Generator     string `xml:"generator"`
		Image         struct {
			URL    string `xml:"url"`
			Title  string `xml:"title"`
			Link   string `xml:"link"`
			Width  string `xml:"width"`
			Height string `xml:"height"`
		} `xml:"image"`
		Language string `xml:"language"`
		Ttl      string `xml:"ttl"`
		Item     []struct {
			Title string `xml:"title"`
			Link  string `xml:"link"`
			Guid  struct {
				IsPermaLink string `xml:"isPermaLink,attr"`
				Content     string `xml:",chardata"`
			} `xml:"guid"`
			Description struct {
				XMLName xml.Name `xml:"description"`
				Rates   string   `xml:",chardata"`
			}
			PubDate string `xml:"pubDate"`
		} `xml:"item"`
	} `xml:"channel"`
}
