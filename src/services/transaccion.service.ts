import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError } from 'rxjs/internal/operators/catchError';

@Injectable({
  providedIn: 'root'
})
export class TransaccionService {

  private apiUrl = 'http://localhost:8086/v1/asignations';
  private urlBulk = 'http://localhost:9898/v1/programs'
  constructor(private http: HttpClient) { }

  getAsignationsList() {
    return this.http.get<any[]>(`${this.apiUrl}/get-assignments`);
  }


saveAsignations(asignation: any) {
  return this.http.post(`${this.urlBulk}/bulk`, asignation).pipe(
    catchError((error: any) => {
      console.error('Error al guardar el adolescente:', error);
      throw error; 
    })
  );
}
}
