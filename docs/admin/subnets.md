# Subnets

## 1. Overview

Subnets는 NABP에서  
**OS 프로비저닝에 사용되는 네트워크 대역을 정의하는 구성 요소**입니다.

Subnets 설정은  
PXE 부팅, DHCP IP 할당, OS 설치 네트워크 구성을 결정하며,  
NABP Configuration 단계의 **첫 번째 핵심 설정**입니다.

---

## 2. Role of Subnets

Subnets는 다음 역할을 수행합니다.

- OS 설치용 네트워크 대역 정의
- DHCP Proxy 연계 및 IP 할당
- PXE Boot 트래픽 제어
- Provisioning Network 구성
- Machine Group 및 ZTP Template의 네트워크 기준 제공

Subnets 설정 오류는  
PXE 부팅 실패 또는 OS 설치 실패로 이어질 수 있습니다.

---

## 3. Configuration Path

Subnets는 다음 경로에서 설정합니다.

Infrastructure  
→ Subnets

---

## 4. Subnet Creation Flow

Subnet 생성은 다음 순서로 진행됩니다.

1. Subnet 기본 정보 입력
2. Network Address 설정
3. Protocol 선택
4. Gateway 설정
5. DHCP Proxy 연결
6. 저장 및 적용

---

## 5. Subnet Parameters

### 5.1 Name

- Subnet을 식별하기 위한 이름
- 일반적으로 네트워크 대역을 포함하여 작성

예시:
- subnet_172.22.0.0_16
- provisioning_net_10.10.0.0_24

---

### 5.2 Protocol

- IPv4 또는 IPv6 선택
- 대부분의 환경에서는 IPv4 사용

---

### 5.3 Network Address

- Subnet의 네트워크 주소
- CIDR 또는 Network/Mask 형식으로 정의

예시:
- 172.22.0.0/16
- 10.10.0.0/24

---

### 5.4 Network Prefix / Netmask

- Network Prefix (CIDR)
- Network Mask (Subnet Mask)

둘 중 하나를 기준으로 네트워크 범위를 정의합니다.

---

### 5.5 Gateway

- OS 설치 시 사용할 기본 Gateway
- Provisioning Network의 라우팅 기준

---

### 5.6 DHCP Proxy

- Subnet에 연결할 DHCP Proxy 선택
- PXE 및 IP 할당을 담당

DHCP Proxy는  
Subnet 생성 시 반드시 지정해야 합니다.

---

## 6. DHCP Proxy Integration

Subnets는 Kea DHCP Proxy와 연계됩니다.

- Subnet 기반 IP Pool 관리
- Host별 MAC 기반 IP 예약
- PXE Boot 옵션 전달
- Proxy 별 Subnet 분리 운영 가능

---

## 7. Usage in Provisioning

Subnets는 다음 단계에서 사용됩니다.

- Machine Group 생성 시 네트워크 기준 제공
- ZTP Template Design 단계에서 노드 네트워크 매핑
- OS 설치 중 IP 자동 할당

Subnet 설정 변경 시  
해당 Subnet을 사용하는 모든 배포 작업에 영향을 미칩니다.

---

## 8. Closed Network Considerations

폐쇄망 환경에서는  
다음 사항을 고려하여 Subnet을 구성해야 합니다.

- 외부 네트워크 접근 불가
- Installation Media 내부 접근 가능 여부 확인
- DHCP, TFTP, HTTP 트래픽 허용

폐쇄망 환경에서는  
Subnet 설정이 OS 설치 성공의 핵심 요소입니다.

---

## 9. Best Practices

- OS 배포용 Subnet과 관리용 Subnet 분리
- 대규모 배포 시 Subnet 별 Proxy 분산
- CIDR 범위는 여유 있게 설계
- Gateway 및 라우팅 사전 검증
- Production / Test Subnet 분리 운영

---

## 10. Common Issues

- Network Address / Netmask 불일치
- Gateway 설정 오류
- DHCP Proxy 미지정
- PXE 옵션 전달 실패

문제 발생 시  
Subnet 설정과 DHCP Proxy 상태를  
우선적으로 점검해야 합니다.

---

## 11. Related Configuration

Subnets는 다음 구성 요소와 연관됩니다.

- DHCP Proxy
- Installation Media
- Operating System
- Machine Group
- ZTP Template
- ZTP Dashboard
