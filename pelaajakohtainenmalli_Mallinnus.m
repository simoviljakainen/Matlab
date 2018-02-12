%% Pelaajakohtainen malli

close all, clear all, clc, format compact

Al = {};
all_points = [];
teams = {'Ilves','?ss?t','HIFK','TPS','HPK','Tappara',...
    'Lukko','SaiPa','KalPa','Sport','K?rp?t','JYP','Pelicans'};

% Joukkueiden nimihistoria
pelicansAlias = {'Pelicans','Kiekkoreipas','Hockey-Reipas','Reipas Lahti'};
jypAlias = {'JYP','JyP HT'};
bluesAlias = {'Blues','Kiekko-Espoo'};

for i=1:length(teams)
    
% Haetaan tietokannasta tarvittavat tiedot
    teamQuery = sqlQuery({'SUM(pdo)','pelaaja','SUM(Maalit)','SUM(syotot)','pelipaikka','SUM(Ottelut)','SUM(Pisteet)','SUM(Rangaistusminuutit)','SUM(LaukausProsentti)','SUM(Laukaukset)','SUM(AloitusProsentti)','SUM(Aloitukset)','SUM(Aika)'},sprintf('WHERE joukkue = "%s" AND vuosi < 2015 AND vuosi > 1999 GROUP BY Pelaaja',teams{i}),'runkosarja_pelaajien_tilastot');
    teamQuery2 = sqlQuery({'pisteet_per_ottelu','vuosi'},sprintf('WHERE joukkue = "%s" AND vuosi < 2015 AND vuosi > 1999',teams{i}),'runkosarja_tilastot');

% Lasketaan joukkue kohtainen pisteet/ottelu
    points = str2double(teamQuery2.Pisteet_per_ottelu)./100;

% Lasketaan painotettu pisteet/ottelu keskiarvo
    sm = 0;

    for j = length(points):-1:1
        sm = sm + points(j)*j;
    end
    
    wpa = sm/sum((length(points)*(length(points)+1))/2);

% Painotetaan pelaajien pelaajien henkil?kohtaisten pdo arvojen summa, 
% kent?ll? olo ajan summan perusteella (tehokkuus arvo)

    pdo = teamQuery.SUM_pdo_.*teamQuery.SUM_Aika_;
    
% Koska k?ytett?v? data on ep?konsistenttia joudutaan poistamaan ??rett?m?t
% ja olemattomat arvot vektorista, jottei tule j?rjett?mi? tuloksia
    pdo(~isfinite(pdo))=0;
    
% Lasketaan joukkueen keskim??r?inen (odotettava) tehokkuus
    l_pdo = sum((pdo/1000))/length(sum(teamQuery.SUM_pdo_(:)~=0));

% Lasketaan joukkueen keskim??r?iset (odotettava) rangaistusminuutit
    rmpero = sum(teamQuery.SUM_Rangaistusminuutit_./teamQuery.SUM_Ottelut_)/length(teamQuery.Pelaaja)*100;
    
% Lasketaan joukkueen pistearvo
A = 1;
B = 1;
    m = (A*l_pdo-B*rmpero)*(sum(points)/length(points));
    
    fprintf('Tiimin %s pisteet:%f\n',teams{i},m)
    Al{end+1} = sprintf('%s : %f',teams{i}, m);
    all_points(end+1) = m; 
    
end

% Tuloksien esitt?minen kaaviossa

high2low = sort(all_points,'descend')
win_teams = {};
point_diff = [];

bar = barh(high2low(1:6),'FaceColor','flat');

for i = 1:6
    win_teams{end+1} = teams{find(all_points==high2low(i))};
    point_diff(end+1) = abs(high2low(i)-high2low(i+1))/high2low(i);
    bar.CData(i,:) = [rand() rand() rand()];
end

set(gca,'yticklabel',win_teams)
title('Jatkoon p??sev?t joukkueet (2015-2016).');
xlabel('Pisteet');