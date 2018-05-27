use books;

insert into customers values
    (3, 'Julie Smith', '25 Oak Street', 'Aireport West'),
    (4, 'Alan Wong', '1/4/ Haines Avenue', 'Box Hill'),
    (5, 'Michelle Arthur', '357 North Road', 'Yarraville');

insert into orders values
    (NULL,  3, 69.98,  2007-04-02),
    (NULL,  1, 49.99,  2007-04-15),
    (NULL,  2, 74.98,  2007-04-19),
    (NULL,  3, 24.99,  2007-05-01);

insert into books values
    ('0-672-31697-8', 'Michael Morgan',
        'Jave 2 for Professional Developers', 34.99),
    ('0-672-31715-1', 'Thomas Down',
        'Installing Debian GNU/Linux', 24.99),
    ('0-672-31599-2', 'Pruitt,eta',
        'Teach Yourself GIMP in 24 Hours', 24.99),
    ('0-672-31769-9', 'Thomas Schenk',
        'Caldera OpenLinux System Administrator Unleashed', 49.99);

insert into order_items values
    (1, '0-672-31697-8', 2),
    (2, '0-672-31769-9', 1),
    (3, '0-672-31769-9', 1),
    (3, '0-672-31599-2', 1),
    (4, '0-672-31745-1', 3);

insert into book_reviews values
('0-672-31697-8', 'The Morgan book is clearly written and goes well beyond most of the basic Java books out there.');