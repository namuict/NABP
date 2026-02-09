# Installation Media

## 1. Overview

Installation Media는 NABP에서 OS 설치에 사용되는  
**설치 이미지 및 Repository 경로를 정의하는 구성 요소**입니다.

NABP는 Installation Media를 통해 다음 작업을 수행합니다.

- OS 설치에 필요한 패키지 및 Repository 제공
- PXE 부팅 이후 OS 설치 이미지 다운로드
- Health Check 단계에서 사용되는 Live OS 이미지 제공

Installation Media는 NABP 설정 과정 중  
**두 번째 필수 구성 단계**에 해당합니다.

---

## 2. Role of Installation Media

Installation Media는 OS 배포 과정 전반에서 핵심적인 역할을 합니다.

- OS 설치 시 참조되는 Repository 경로 제공
- Kickstart / Preseed 파일에서 사용
- OS 설치 전 Health Check 수행 시 Live OS 다운로드 경로 제공

특히 폐쇄망 환경에서는  
Installation Media 설정 여부가 OS 배포 성공 여부를 결정합니다.

---

## 3. Supported Media Types

Installation Media는 다음과 같은 방식으로 제공될 수 있습니다.

- 외부 Web Server (HTTP / HTTPS)
- NABP 내부 Local Repository
- 사내 Repository 서버 (Apache / Nginx 등)

Media Path는 NABP가 접근 가능한 네트워크 내에 위치해야 합니다.

---

## 4. Configuration Path

Installation Media는 다음 경로에서 설정합니다.

Contents  
→ Installation Media

---

## 5. Installation Media Parameters

Installation Media 생성 시 다음 항목을 설정해야 합니다.

### 5.1 Name

- Installation Media를 식별하기 위한 이름
- 일반적으로 OS 이름과 버전을 포함하여 작성

예시:
- AlmaLinux_9.2
- RockyLinux_8.9
- Ubuntu_22.04

---

### 5.2 Media Path

- OS 설치 이미지 및 Repository가 위치한 경로
- HTTP 또는 HTTPS 기반 URL

예시:
- http://repo.example.com/almalinux/9.2/
- http://nabp.local/media/centos/7/

---

### 5.3 OS Family

- 설치할 OS의 계열 선택
- 이후 OS 정의 단계에서 필터 기준으로 사용됨

예시:
- RedHat
- Debian
- SUSE

---

## 6. Closed Network Considerations

폐쇄망 환경에서는 외부 Repository 접근이 불가능하므로  
반드시 내부 Media Path를 구성해야 합니다.

이 경우 다음 방식이 권장됩니다.

- NABP 내부에 Local Repository 구성
- 필수 OS 패키지만 선별하여 제공
- Apache 또는 Nginx 기반 Web Server 사용

폐쇄망 환경에서는  
Health Check 단계에서도 Installation Media가 사용되므로  
Live OS 이미지가 포함되어야 합니다.

---

## 7. Usage in Provisioning Workflow

Installation Media는 다음 단계에서 사용됩니다.

- Operating System 정의 시 Media 선택
- Provisioning Workflow 실행 중 OS 설치 단계
- Health Check Workflow 실행 시 Live OS 다운로드

OS 배포 과정 중 Media Path 접근 실패 시  
배포는 즉시 실패 처리됩니다.

---

## 8. Best Practices

- OS 버전별로 Installation Media를 분리하여 관리
- Media Path 변경 시 사전 테스트 수행
- 폐쇄망 환경에서는 불필요한 패키지 제거
- OS 업데이트 정책에 따라 Media 버전 관리

---

## 9. Common Issues

- Media Path 접근 불가
- Repository 구조 오류
- OS Family 불일치
- 폐쇄망 환경에서 외부 URL 사용

문제 발생 시 Media Path 접근 여부를  
우선적으로 확인해야 합니다.

---

## 10. Related Configuration

Installation Media는 다음 구성 요소와 연관됩니다.

- Operating System
- Provisioning Workflow
- Health Check Workflow
- Machine Group


