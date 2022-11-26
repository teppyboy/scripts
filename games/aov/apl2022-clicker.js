if (!window.location.href.startsWith("https://apl2022.lienquan.garena.vn")) {
    console.error("This script is for https://apl2022.lienquan.garena.vn only.");
}

async function getCurrentUser() {
    const rsp = await fetch('/graphql', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            operationName: "getUser",
            query: `
                query getUser {
                    getUser {
                        id
                        name
                        icon
                        profile {
                        id
                        ...Profile
                        __typename
                        }
                        __typename
                    }
                }

                fragment Profile on Profile {
                    tcid
                    clicks
                    totalClicks
                    dailyClicks
                    claimedGift
                    currentGift
                    receivedServerGift
                    subMissions
                    claimedDailyGift
                    date
                    item {
                        id
                        name
                        type
                        image
                        limitation
                        currentClaimed
                        __typename
                    }
                    sentWish
                    __typename
                }
            `,
            variables: {},
        }),
    })
    if (!rsp.ok) {
        throw `Failed to get current user info`
    }
    return (await rsp.json()).data.getUser;
}

async function postClick(amount) {
    const rsp = await fetch('/graphql', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            operationName: "doDailyClick",
            query: `
                mutation doDailyClick($clicks: Int!) {
                    dailyClick(clicks: $clicks) {
                        id
                        ...Profile
                        __typename
                    }
                }

                fragment Profile on Profile {
                    tcid
                    clicks
                    totalClicks
                    dailyClicks
                    claimedGift
                    currentGift
                    receivedServerGift
                    subMissions
                    claimedDailyGift
                    date
                    item {
                        id
                        name
                        type
                        image
                        limitation
                        currentClaimed
                        __typename
                    }
                    sentWish
                    __typename
                }
            `,
            variables: {
                clicks: amount,
            },
        }),
    })
    if (!rsp.ok) {
        throw `Failed to post click request with amount ${amount}`
    }
}

async function main() {
    console.log("Fetching user information...");
    let user;
    try {
        user = await getCurrentUser();
    } catch(e) {
        console.error(e);
        return;
    }
    console.log(`Hello, ${user.name}!`);
    console.log("Calculating remaining clicks needed...");
    const clicksNeeded = 1000 - user.profile.dailyClicks;
    if (clicksNeeded == 0) {
        console.warn("You've already clicked enough for a day :D");
        return;
    }
    console.log(`Clicks needed: ${clicksNeeded}`);
    console.log("Sending click request...");
    try {
        postClick(clicksNeeded);
    } catch(e) {
        console.error(e);
        return;
    }
    console.log("Success! Please reload page to see the changes.");
}

main()
