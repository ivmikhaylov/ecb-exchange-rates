package beWriter

type singlePublication struct {
	PUB_DATETIME string
	PUB_TITLE    string
	PUB_LINK     string
	PUB_GUID     string
}

type ManyPublications []singlePublication
