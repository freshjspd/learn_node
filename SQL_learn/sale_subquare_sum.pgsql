SELECT CV.idorder, (CV.countProduct * P.price) as "sumP"
FROM CashVoucher as CV
JOIN Products as P ON P.id = CV.idproduct
GROUP BY CV.idorder, CV.countProduct, P.price;

UPDATE CashVoucher
SET sumProduct = CV.countProduct * Products.price
FROM CashVoucher as CV JOIN Products ON CV.idProduct = Products.id
WHERE CV.idOrder = 1;

UPDATE CashVoucher as CV
SET sumProduct = Res.sumP
FROM CashVoucher ,
    (SELECT CV.id, CV.idorder, (CV.countProduct * P.price) as sumP
    FROM CashVoucher as CV
    JOIN Products as P ON P.id = CV.idproduct
    GROUP BY CV.id, CV.idorder, CV.countProduct, P.price) as Res
WHERE Res.idorder = CV.idorder and CV.id = Res.id;

SELECT * FROM cashvoucher;