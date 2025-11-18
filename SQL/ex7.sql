-- show the advertisement in the soccer match
-- don't show how much money the advertiser spent
CREATE VIEW MatchAdvertisement
AS SELECT advertisementId, advertiserName, message
   FROM Advertisement;
   

