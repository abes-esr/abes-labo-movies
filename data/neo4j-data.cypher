MATCH (n) DELETE n;

CREATE (:University {title:'Université de Montpellier', uai: '0342321N'});
CREATE (:University {title:'Université de Nimes', uai: '??????'});

MATCH (n) RETURN n;
