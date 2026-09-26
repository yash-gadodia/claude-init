# Prose tropes a model drifts into

Each entry is the trope, one example, and the plain sentence that replaces it. The repair is always the same: say the literal thing. Metaphor, suspense, and rhythm exist to display the writer; a reader who wants the idea has to work through them, and a model that reads them parrots them into contact-facing text. The reference behind the deslop skill's prose lane, condensed from the lws.io CLAUDE.md trope list and the mannered-prose definition in Anthropic's Fable 5.1 prompting guide.

## Word choice

- Magic adverbs ("quietly orchestrating", "fundamentally", "remarkably", "arguably") make a plain fact sound weighty. Delete the adverb; if the fact is important, the sentence around it shows why.
- Overused vocabulary: delve, leverage (verb), robust, streamline, harness, utilize, certainly, tapestry, landscape, paradigm, ecosystem, synergy. Each has a plain word: look at, use, reliable, simplify, field.
- The "serves as" dodge ("the table serves as the ledger", "marks a pivotal moment", "represents a shift"). Write "is".
- Invented concept labels ("the supervision paradox", "workload creep", "the acceleration trap") name a thing so the argument can be skipped, and the next reader treats the label as an established term. Make the argument; if a new idea needs a word, define it at first use.

## Sentence structure

- Negative parallelism ("it's not X, it's Y", "not because X but because Y", "the question isn't X; the question is Y") frames every point as a surprise reframe. State Y.
- The countdown ("not a bug, not a feature, a design flaw") negates two things before the point. State the point.
- The self-answered question ("The result? Devastating." "The worst part? Nobody noticed."). Join the two halves into one declarative sentence.
- Anaphora and stacked tricolons (three sentences opening the same way; "identity, payments, compute, distribution"; three rule-of-three sentences in a row). One triple per piece is rhythm; the second is a pattern. Vary length and opening.
- Filler transitions ("it's worth noting", "importantly", "interestingly", "notably") announce a point without connecting it. Delete the transition and connect the point to the previous one, or start the sentence with the point.
- Trailing participle analysis ("...highlighting its importance", "...reflecting broader trends", "...underscoring its role as a hub") attaches unearned significance. Cut the clause.
- False ranges ("from innovation to cultural transformation") list two things dressed as a spectrum. Name the two things, or the real scale.

## Paragraph and composition

- Short punchy fragments as paragraphs ("Openly. In a book. As a priest.") manufacture emphasis. Write the sentence.
- The listicle in a trench coat ("The first wall is... The second wall is...") is a list wearing paragraphs. Use a list, or write prose whose paragraphs are not numbered.
- Fractal summaries (each section previews itself and recaps itself, then the document does it again) write every fact twice. Open on the first decision, close on the last; the frontmatter summary is the only summary.
- The dead metaphor (walls and doors thirty times in one piece) is a metaphor that was never allowed to end. Use it once or not at all.
- Historical analogy stacking ("Apple didn't build Uber. Stripe didn't build Shopify...") borrows authority from a list. One example, with its specifics, or none.
- One-point dilution restates a thesis in ten framings across four thousand words. One argument gets one statement and the evidence for it.
- Signposted conclusions ("In conclusion", "To sum up"), fractal recaps, and "despite these challenges, X thrives" endings. Stop when the content stops.

## Tone

- False suspense ("here's the kicker", "here's the thing", "here's where it gets interesting") promises a reveal the sentence does not deliver. Delete the setup.
- The patronizing analogy ("think of it as a highway for data", "it's like a Swiss Army knife") assumes the reader needs a picture; the picture is usually less precise than the concept. State the concept.
- "Imagine a world where..." sells the premise before arguing it. Argue it.
- Performed vulnerability ("and yes, I'll admit I love this model") is authenticity with no cost. Say the specific, uncomfortable thing or nothing.
- Asserted obviousness ("the truth is simple", "history is unambiguous", "the real story is...") replaces proof. Give the proof; if it is obvious, the reader will notice.
- Stakes inflation ("will define the next era", "fundamentally reshape everything"). State the actual consequence at its actual size.
- The teacher voice ("let's break this down", "let's unpack", "let's dive in") assumes a student. The reader is a peer; start with the point.
- Vague attribution ("experts argue", "industry reports suggest", "several sessions found") is a claim nobody can follow. Name the source, the commit, the incident, the session id; if you cannot, you do not have a source.

## Formatting

- Em dashes are banned in every model-visible string and, where the project adopts the rule, in its docs and commits. Use a comma, a colon, a full stop, or parentheses.
- Bold-first bullets (every item opening with a bolded phrase and a colon) are the AI-documentation signature. Bold a lead phrase only where the reader scans for it; most lists need no bold at all.
- Unicode decoration (arrows, smart quotes, box characters) is not what a person types in an editor. Straight quotes, and "then" or a comma where an arrow would go.
- Exclamation points and AI triplets ("efficient, scalable, and robust") read as sales copy. Drop the mark; name the one property that matters.
