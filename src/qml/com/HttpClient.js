function fetch(url) {
    let rawPromise = HttpClient.fetch(
            url)
    return {
        "then": function (onSuccess) {
            rawPromise.success.connect(
                        onSuccess)
            return this
        },
        "error": function (onError) {
            rawPromise.error.connect(
                        onError)
            return this
        }
    }
}

function songDetail(id, onSuccess, onError) {
    fetch(`/song/detail?ids=${id}`).then(
                result => {
                    let imgurl = JSON.parse(
                        result).songs[0].al.picUrl
                    onSuccess(imgurl)
                }).error(onError)
}
