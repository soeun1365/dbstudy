-- �������̼� (�θ����̺�)
CREATE TABLE ��
(
�����̵� VARCHAR2(30) PRIMARY KEY,
���̸� NVARCHAR2(30),          --30����Ʈ �ִ� 15��, NVARCHAR2(30)�� �ִ� �ѱ�30����,���� 60
���� NUMBER(3),                  --�ִ�3��
��� CHAR(1),                    --�ѱ��� ������
���� VARCHAR2(5),                --�ڵ�� 5��
������ NUMBER(7)                 --�鸸���ڸ�����
);

--�ֹ������̼� (�ڽ����̺�)
CREATE TABLE �ֹ�
(
�ֹ���ȣ NUMBER PRIMARY KEY,
�ֹ��� VARCHAR2(30) REFERENCES ��(�����̵�),              -- FOREIGN KEY �ܷ�Ű(�����̺��� �����̵� Į���� ����) �ݵ�� Ÿ���� ���� �������, �̸��� �޶󵵵�
�ֹ���ǰ VARCHAR2(20),
���� NUMBER,
�ܰ� NUMBER,
�ֹ����� DATE
);

SELECT * FROM ��;

DROP TABLE ��;