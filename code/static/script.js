export async function findActiveGames(page) {
    let activeGames = await fetch(`/page/${page}/`)
        .then(response => response.json())
        .then(data => {
            console.log(data);
            return data;
        })
        .catch(error => {
            console.error('Error fetching data:', error);
        });

    return activeGames;
}