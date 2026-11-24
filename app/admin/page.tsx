"use client";
import {useEffect,useState} from "react";
import {supabase} from "@/lib/supabase";
type Item={id:string;sku:string;name:string;category:string;status:string;price:number|null;image_url:string|null;description:string|null;size:string|null;included:string|null;is_published:boolean};
const blank={sku:"",name:"",category:"Melayu",status:"Tersedia",price:"",description:"",size:"",included:"",is_published:true};
export default function Admin(){
 const [session,setSession]=useState<any>(null),[items,setItems]=useState<Item[]>([]),[form,setForm]=useState<any>(blank),[file,setFile]=useState<File|null>(null),[edit,setEdit]=useState<string|null>(null),[msg,setMsg]=useState("");
 async function load(){const {data,error}=await supabase.from("collections").select("*").order("created_at",{ascending:false});if(error){setMsg(error.message);return}setItems((data||[]) as Item[])}
 useEffect(()=>{supabase.auth.getSession().then(({data})=>setSession(data.session));const {data:{subscription}}=supabase.auth.onAuthStateChange((_e,s)=>setSession(s));return()=>subscription.unsubscribe()},[]);
 useEffect(()=>{if(session)load()},[session]);
 async function save(e:React.FormEvent){e.preventDefault();setMsg("Menyimpan...");let image_url:string|undefined;
  if(file){const path=`${Date.now()}-${file.name.replace(/[^a-zA-Z0-9.-]/g,"-")}`;const up=await supabase.storage.from("collection-photos").upload(path,file,{upsert:false});if(up.error){setMsg(up.error.message);return}image_url=supabase.storage.from("collection-photos").getPublicUrl(path).data.publicUrl}
  const payload={sku:form.sku,name:form.name,category:form.category,status:form.status,price:form.price===""?null:Number(form.price),description:form.description||null,size:form.size||null,included:form.included||null,is_published:form.is_published,...(image_url?{image_url}:{})};
  const result=edit?await supabase.from("collections").update(payload).eq("id",edit):await supabase.from("collections").insert(payload);
  if(result.error){setMsg(result.error.message);return}setForm(blank);setFile(null);setEdit(null);setMsg("Koleksi berhasil disimpan.");load();
 }
 async function remove(id:string){if(!confirm("Hapus koleksi ini?"))return;const {error}=await supabase.from("collections").delete().eq("id",id);setMsg(error?.message||"Koleksi dihapus.");load()}
 async function logout(){await supabase.auth.signOut();setSession(null)}
 if(!session)return <main className="admin"><a href="/" className="eyebrow">← Kembali ke katalog</a><div className="panel"><h1>Admin NUSSA</h1><p className="muted">Masuk untuk mengelola koleksi katalog.</p><form onSubmit={async e=>{e.preventDefault();const f=e.currentTarget as HTMLFormElement;const {error}=await supabase.auth.signInWithPassword({email:(f.elements.namedItem("email") as HTMLInputElement).value,password:(f.elements.namedItem("password") as HTMLInputElement).value});setMsg(error?.message||"")}}><p><input name="email" type="email" placeholder="Email admin" required style={{padding:12,width:"100%"}}/></p><p><input name="password" type="password" placeholder="Password" required style={{padding:12,width:"100%"}}/></p><button className="btn primary">Login</button></form><p className="muted">{msg}</p></div></main>;
 return <main className="admin"><div className="row"><div><div className="brand">NUSSA</div><div className="eyebrow">Panel Admin Katalog</div></div><button className="btn" onClick={logout}>Keluar</button></div>
 <section className="panel"><h2>{edit?"Edit Koleksi":"Tambah Koleksi"}</h2><form onSubmit={save}><div className="formgrid">
 <input required placeholder="Kode koleksi / SKU" value={form.sku} onChange={e=>setForm({...form,sku:e.target.value})}/><input required placeholder="Nama koleksi" value={form.name} onChange={e=>setForm({...form,name:e.target.value})}/>
 <select value={form.category} onChange={e=>setForm({...form,category:e.target.value})}>{["Melayu","Dayak","Jawa","Bali","Nusantara Lainnya"].map(x=><option key={x}>{x}</option>)}</select><select value={form.status} onChange={e=>setForm({...form,status:e.target.value})}>{["Tersedia","Disewa","Perawatan","Tidak aktif"].map(x=><option key={x}>{x}</option>)}</select>
 <input type="number" min="0" placeholder="Harga sewa (Rp)" value={form.price} onChange={e=>setForm({...form,price:e.target.value})}/><input placeholder="Ukuran" value={form.size} onChange={e=>setForm({...form,size:e.target.value})}/>
 <input className="wide" placeholder="Kelengkapan busana" value={form.included} onChange={e=>setForm({...form,included:e.target.value})}/><input className="wide" placeholder="Deskripsi singkat" value={form.description} onChange={e=>setForm({...form,description:e.target.value})}/>
 <input className="wide" type="file" accept="image/*" onChange={e=>setFile(e.target.files?.[0]||null)}/><label className="wide"><input type="checkbox" checked={form.is_published} onChange={e=>setForm({...form,is_published:e.target.checked})}/> Tampilkan di katalog publik</label>
 </div><p><button className="btn primary">Simpan Koleksi</button> <button type="button" className="btn" onClick={()=>{setForm(blank);setEdit(null);setFile(null)}}>Reset</button></p></form><p className="muted">{msg}</p></section>
 <section className="panel"><h2>Daftar Koleksi ({items.length})</h2>{items.map(x=><div className="row" key={x.id}><div><b>{x.name}</b><div className="muted">{x.sku} · {x.category} · {x.status} · {x.is_published?"Publik":"Draft"}</div></div><div><button className="btn" onClick={()=>{setEdit(x.id);setForm({...x,price:x.price??""});window.scrollTo({top:0,behavior:"smooth"})}}>Edit</button> <button className="danger" onClick={()=>remove(x.id)}>Hapus</button></div></div>)}</section>
 </main>;
}
