.pragma library

function jaro(s1, s2) {
    if (s1 === s2) {
        return 1.0;
    }

    var len1 = s1.length;
    var len2 = s2.length;

    if (len1 === 0 || len2 === 0) {
        return 0.0;
    }

    var matchDistance = Math.floor(Math.max(len1, len2) / 2) - 1;

    var s1Matches = new Array(len1).fill(false);
    var s2Matches = new Array(len2).fill(false);

    var matches = 0;
    for (var i = 0; i < len1; i++) {
        var start = Math.max(0, i - matchDistance);
        var end = Math.min(i + matchDistance + 1, len2);

        for (var j = start; j < end; j++) {
            if (s2Matches[j]) continue;
            if (s1[i] !== s2[j]) continue;
            s1Matches[i] = true;
            s2Matches[j] = true;
            matches++;
            break;
        }
    }

    if (matches === 0) {
        return 0.0;
    }

    var transpositions = 0;
    var k = 0;
    for (var i = 0; i < len1; i++) {
        if (!s1Matches[i]) continue;
        while (!s2Matches[k]) k++;
        if (s1[i] !== s2[k]) transpositions++;
        k++;
    }

    transpositions /= 2;

    return (matches / len1 + matches / len2 + (matches - transpositions) / matches) / 3.0;
}

function jaroWinkler(s1, s2, prefixScale) {
    var p = (prefixScale !== undefined) ? prefixScale : 0.1;
    var jaroDistance = jaro(s1, s2);

    var prefixLength = 0;
    for (var i = 0; i < Math.min(4, s1.length, s2.length); i++) {
        if (s1[i] === s2[i]) {
            prefixLength++;
        } else {
            break;
        }
    }

    return jaroDistance + prefixLength * p * (1 - jaroDistance);
}

function fuzzyMatch(s1, s2) {
    return jaroWinkler(s1, s2);
}

function scoreAgainst(query, text) {
    var full = jaroWinkler(query, text);
    var words = text.split(/[\s\-_]+/);
    var squished = words.join("");
    var best = full;

    // substring match in squished text (catches "code" in "visualstudiocode", "viscode", etc.)
    if (squished.indexOf(query) !== -1) {
        best = 1.0;
    }

    // acronym match (catches "vsc" → "Visual Studio Code")
    var acronym = "";
    for (var i = 0; i < words.length; i++) {
        if (words[i].length > 0) acronym += words[i][0];
    }
    if (acronym.length > 1) {
        best = Math.max(best, jaroWinkler(query, acronym));
    }

    for (var i = 0; i < words.length; i++) {
        if (words[i].length === 0) continue;
        var s = jaroWinkler(query, words[i]);
        if (s > best) best = s;
    }
    return best;
}

function rankByKey(query, candidates, keyFn, threshold) {
    var q = query.toLowerCase();
    var min = threshold !== undefined ? threshold : 0.7;

    return candidates
        .filter(c => keyFn(c) != null)
        .map(c => ({ item: c, score: scoreAgainst(q, keyFn(c).toLowerCase()) }))
        .filter(r => r.score >= min)
        .sort((a, b) => b.score - a.score)
        .map(r => r.item);
}

function rankMatches(query, candidates, threshold) {
    return rankByKey(query, candidates, s => s, threshold);
}
